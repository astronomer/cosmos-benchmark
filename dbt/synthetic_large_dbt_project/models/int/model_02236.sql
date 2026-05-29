{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01104') }},
        {{ ref('model_01495') }},
        {{ ref('model_01184') }}
)
select id, 'model_02236' as name from sources
