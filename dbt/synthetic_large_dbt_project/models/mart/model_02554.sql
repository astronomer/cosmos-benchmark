{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01883') }},
        {{ ref('model_02159') }}
)
select id, 'model_02554' as name from sources
