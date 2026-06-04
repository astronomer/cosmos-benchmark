{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02187') }},
        {{ ref('model_02024') }},
        {{ ref('model_01915') }}
)
select id, 'model_02646' as name from sources
