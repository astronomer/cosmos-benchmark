{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01154') }},
        {{ ref('model_01059') }},
        {{ ref('model_00839') }}
)
select id, 'model_01504' as name from sources
