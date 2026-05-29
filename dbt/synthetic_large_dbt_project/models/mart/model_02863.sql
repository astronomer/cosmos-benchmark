{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02054') }},
        {{ ref('model_01581') }},
        {{ ref('model_02229') }}
)
select id, 'model_02863' as name from sources
