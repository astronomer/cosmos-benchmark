{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00974') }},
        {{ ref('model_01469') }},
        {{ ref('model_00839') }}
)
select id, 'model_01891' as name from sources
