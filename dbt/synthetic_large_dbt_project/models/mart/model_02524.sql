{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01911') }},
        {{ ref('model_01545') }}
)
select id, 'model_02524' as name from sources
