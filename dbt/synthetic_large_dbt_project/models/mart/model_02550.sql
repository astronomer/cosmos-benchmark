{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01732') }},
        {{ ref('model_01911') }},
        {{ ref('model_01628') }}
)
select id, 'model_02550' as name from sources
