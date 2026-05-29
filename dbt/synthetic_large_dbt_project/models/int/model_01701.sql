{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01141') }},
        {{ ref('model_01273') }}
)
select id, 'model_01701' as name from sources
