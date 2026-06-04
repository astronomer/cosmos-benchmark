{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01043') }},
        {{ ref('model_01267') }}
)
select id, 'model_01530' as name from sources
