{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01942') }},
        {{ ref('model_01521') }},
        {{ ref('model_01911') }}
)
select id, 'model_02393' as name from sources
