{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00848') }},
        {{ ref('model_00958') }},
        {{ ref('model_00784') }}
)
select id, 'model_02087' as name from sources
