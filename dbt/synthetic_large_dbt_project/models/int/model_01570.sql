{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01161') }},
        {{ ref('model_01353') }}
)
select id, 'model_01570' as name from sources
