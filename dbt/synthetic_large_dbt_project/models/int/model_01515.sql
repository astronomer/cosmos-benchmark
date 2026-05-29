{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01102') }},
        {{ ref('model_01198') }}
)
select id, 'model_01515' as name from sources
