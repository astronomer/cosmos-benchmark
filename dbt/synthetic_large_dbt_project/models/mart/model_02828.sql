{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02248') }},
        {{ ref('model_01540') }}
)
select id, 'model_02828' as name from sources
