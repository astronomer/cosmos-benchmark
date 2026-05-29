{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02187') }},
        {{ ref('model_02080') }}
)
select id, 'model_02570' as name from sources
